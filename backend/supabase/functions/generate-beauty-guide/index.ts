// ============================================
// 1. 필요한 라이브러리 import
// ============================================
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// CORS 설정
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// ============================================
// 2. 메인 함수
// ============================================
serve(async (req) => {
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // ============================================
    // 3. 요청 데이터 파싱
    // ============================================
    const { analysisId, guideType = 'makeup_basic' } = await req.json()
    
    console.log('가이드 생성 요청:', { analysisId, guideType })
    
    if (!analysisId) {
      throw new Error('analysisId가 필요합니다.')
    }

    // ============================================
    // 4. Supabase 클라이언트 생성
    // ============================================
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey)
    
    console.log('Supabase 연결 완료')

    // ============================================
    // 5. 분석 결과 가져오기
    // ============================================
    const { data: analysis, error: analysisError } = await supabase
      .from('analyses')
      .select(`
        *,
        profiles (
          name,
          skin_type,
          birth_year
        )
      `)
      .eq('id', analysisId)
      .single()
    
    if (analysisError || !analysis) {
      throw new Error('분석 결과를 찾을 수 없습니다: ' + analysisError?.message)
    }
    
    console.log('분석 결과 가져옴:', analysis.personal_color)

    // ============================================
    // 6. GPT 프롬프트 생성
    // ============================================
    const prompt = createPrompt(analysis, guideType)
    console.log('프롬프트 생성 완료')

    // ============================================
    // 7. OpenAI API 호출
    // ============================================
    const openaiApiKey = Deno.env.get('OPENAI_API_KEY')
    
    if (!openaiApiKey) {
      throw new Error('OPENAI_API_KEY 환경 변수가 설정되지 않았습니다.')
    }
    
    console.log('OpenAI 호출 중...')
    
    const gptResponse = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${openaiApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: '당신은 전문 뷰티 컨설턴트입니다. 친근하고 이해하기 쉬운 언어로 맞춤형 뷰티 가이드를 작성해주세요.'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.7,
        max_tokens: 1500
      })
    })
    
    if (!gptResponse.ok) {
      throw new Error(`OpenAI API 오류: ${gptResponse.status}`)
    }
    
    const gptData = await gptResponse.json()
    const guideContent = gptData.choices[0].message.content
    
    console.log('GPT 응답 받음 (길이:', guideContent.length, ')')

    // ============================================
    // 8. 가이드를 데이터베이스에 저장
    // ============================================
    const { data: savedGuide, error: saveError } = await supabase
      .from('beauty_guides')
      .insert({
        user_id: analysis.user_id,
        analysis_id: analysisId,
        guide_type: guideType,
        title: getGuideTitle(guideType, analysis),
        content: guideContent,
        model_used: 'gpt-4',
        tokens_used: gptData.usage?.total_tokens || 0,
      })
      .select()
      .single()
    
    if (saveError) {
      console.error('저장 오류:', saveError)
      throw saveError
    }
    
    console.log('가이드 저장 완료:', savedGuide.id)

    // ============================================
    // 9. 성공 응답 반환
    // ============================================
    return new Response(
      JSON.stringify({
        success: true,
        guide_id: savedGuide.id,
        title: savedGuide.title,
        content: guideContent,
        guide_type: guideType,
      }),
      { 
        headers: { 
          ...corsHeaders,
          'Content-Type': 'application/json' 
        },
        status: 200 
      }
    )
    
  } catch (error) {
    // ============================================
    // 10. 에러 처리
    // ============================================
    console.error('에러:', error.message)
    
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: error.message 
      }),
      { 
        headers: { 
          ...corsHeaders,
          'Content-Type': 'application/json' 
        },
        status: 400 
      }
    )
  }
})

// ============================================
// 헬퍼 함수: 프롬프트 생성
// ============================================
function createPrompt(analysis: any, guideType: string): string {
  const profile = analysis.profiles
  
  return `
사용자 정보:
- 이름: ${profile?.name || '사용자'}님
- 퍼스널컬러: ${analysis.personal_color} (신뢰도: ${(analysis.personal_color_confidence * 100).toFixed(0)}%)
- 언더톤: ${analysis.undertone}
- 민감성 점수: ${analysis.sensitivity_score}/10
- 피부 타입: ${profile?.skin_type || '정보 없음'}
- 피부 고민: ${analysis.risk_factors?.join(', ') || '없음'}

${getGuideTypeInstructions(guideType)}

형식:
- 친근한 말투 사용 ("~해요", "~세요")
- 섹션별로 명확히 구분
- 구체적인 제품명이나 색상명 포함
- 초보자도 따라할 수 있도록 쉽게 설명
- 주의사항은 반드시 포함
`
}

// ============================================
// 헬퍼 함수: 가이드 타입별 지시사항
// ============================================
function getGuideTypeInstructions(guideType: string): string {
  switch (guideType) {
    case 'makeup_basic':
      return `
요청사항:
1. 어울리는 메이크업 컬러 3가지 추천 (구체적 색상명 포함)
2. 5단계 기초 메이크업 순서
3. 민감성 피부를 위한 주의사항
4. 초보자를 위한 실용적 팁
`
    case 'skincare_routine':
      return `
요청사항:
1. 아침 스킨케어 루틴 (5단계)
2. 저녁 스킨케어 루틴 (7단계)
3. 추천 성분 및 제품 타입
4. 피해야 할 성분
`
    case 'color_matching':
      return `
요청사항:
1. 어울리는 의상 컬러 팔레트
2. 피해야 할 컬러
3. 액세서리 색상 추천
4. 헤어 컬러 추천
`
    default:
      return '맞춤형 뷰티 가이드를 작성해주세요.'
  }
}

// ============================================
// 헬퍼 함수: 가이드 제목 생성
// ============================================
function getGuideTitle(guideType: string, analysis: any): string {
  const season = analysis.personal_color
  const seasonName = {
    spring: '봄웜톤',
    summer: '여름쿨톤',
    autumn: '가을웜톤',
    winter: '겨울쿨톤'
  }[season] || season
  
  switch (guideType) {
    case 'makeup_basic':
      return `${seasonName}을 위한 기초 메이크업 가이드`
    case 'skincare_routine':
      return `${seasonName}을 위한 스킨케어 루틴`
    case 'color_matching':
      return `${seasonName}을 위한 컬러 매칭 가이드`
    default:
      return `${seasonName} 맞춤 뷰티 가이드`
  }
}