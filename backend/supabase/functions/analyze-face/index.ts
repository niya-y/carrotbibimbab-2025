// ============================================
// 1. 필요한 라이브러리 import
// ============================================
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// CORS 설정 (Flutter에서 호출 가능하게)
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// ============================================
// 2. 메인 함수: HTTP 요청을 받아서 처리
// ============================================
serve(async (req) => {
  // OPTIONS 요청 처리 (CORS preflight)
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // ============================================
    // 3. 요청 데이터 파싱
    // ============================================
    const { imageId, userId } = await req.json()
    
    console.log('분석 요청 받음:', { imageId, userId })
    
    // 필수 파라미터 체크
    if (!imageId || !userId) {
      throw new Error('imageId와 userId가 필요합니다.')
    }

    // ============================================
    // 4. Supabase 클라이언트 생성
    // ============================================
    // 환경 변수에서 URL과 키를 가져옴
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    
    // service_role 키로 클라이언트 생성 (RLS 무시 가능)
    const supabase = createClient(supabaseUrl, supabaseServiceKey)
    
    console.log('Supabase 클라이언트 생성 완료')

    // ============================================
    // 5. 이미지 정보 가져오기
    // ============================================
    const { data: imageData, error: imageError } = await supabase
      .from('uploaded_images')
      .select('*')
      .eq('id', imageId)
      .eq('user_id', userId)
      .single()
    
    if (imageError || !imageData) {
      throw new Error('이미지를 찾을 수 없습니다: ' + imageError?.message)
    }
    
    console.log('이미지 정보 가져옴:', imageData.image_url)

    // ============================================
    // 6. 분석 상태를 'processing'으로 업데이트
    // ============================================
    await supabase
      .from('uploaded_images')
      .update({ 
        analysis_status: 'processing',
        analyzed_at: new Date().toISOString()
      })
      .eq('id', imageId)
    
    console.log('⏳ 분석 상태: processing')

    // ============================================
    // 7. AI 서버에 분석 요청
    // ============================================
    const aiServerUrl = Deno.env.get('AI_SERVER_URL')
    
    if (!aiServerUrl) {
      throw new Error('AI_SERVER_URL 환경 변수가 설정되지 않았습니다.')
    }
    
    console.log('AI 서버 호출 중:', aiServerUrl)
    
    const aiResponse = await fetch(`${aiServerUrl}/analyze`, {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        image_url: imageData.image_url,
        user_id: userId
      })
    })
    
    if (!aiResponse.ok) {
      throw new Error(`AI 서버 오류: ${aiResponse.status}`)
    }
    
    const analysisResult = await aiResponse.json()
    console.log('AI 분석 완료')

    // ============================================
    // 8. 분석 결과를 데이터베이스에 저장
    // ============================================
    const { data: savedAnalysis, error: saveError } = await supabase
      .from('analyses')
      .insert({
        user_id: userId,
        image_id: imageId,
        
        // 스킨톤 정보
        skin_tone_rgb: analysisResult.skin_tone?.rgb_average,
        skin_tone_lab: analysisResult.skin_tone?.lab_values,
        undertone: analysisResult.skin_tone?.undertone,
        undertone_confidence: analysisResult.skin_tone?.undertone_confidence,
        
        // 퍼스널컬러 정보
        personal_color: analysisResult.personal_color?.season,
        personal_color_confidence: analysisResult.personal_color?.season_confidence,
        personal_color_characteristics: analysisResult.personal_color?.characteristics,
        
        // 민감성 피부 정보
        sensitivity_score: analysisResult.sensitivity_analysis?.score,
        risk_factors: analysisResult.sensitivity_analysis?.risk_factors,
        caution_ingredients: analysisResult.sensitivity_analysis?.caution_ingredients,
        safe_ingredients: analysisResult.sensitivity_analysis?.safe_ingredients,
        recommendations: analysisResult.sensitivity_analysis?.recommendations,
        
        // 기타 정보
        face_landmarks: analysisResult.face_landmarks,
        face_quality_score: analysisResult.face_quality_score,
        analysis_data: analysisResult, // 전체 데이터 백업
      })
      .select()
      .single()
    
    if (saveError) {
      console.error('데이터베이스 저장 오류:', saveError)
      throw saveError
    }
    
    console.log('데이터베이스 저장 완료:', savedAnalysis.id)

    // ============================================
    // 9. 이미지 상태를 'completed'로 업데이트
    // ============================================
    await supabase
      .from('uploaded_images')
      .update({ analysis_status: 'completed' })
      .eq('id', imageId)
    
    console.log('분석 완료!')

    // ============================================
    // 10. 성공 응답 반환
    // ============================================
    return new Response(
      JSON.stringify({
        success: true,
        analysis_id: savedAnalysis.id,
        data: {
          personal_color: savedAnalysis.personal_color,
          undertone: savedAnalysis.undertone,
          sensitivity_score: savedAnalysis.sensitivity_score,
        }
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
    // 11. 에러 처리
    // ============================================
    console.error('에러 발생:', error.message)
    
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