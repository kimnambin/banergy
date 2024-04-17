from flask import Flask, jsonify, request
from paddleocr import PaddleOCR
import os

ocr = PaddleOCR(lang="korean")
app = Flask(__name__)

# 이미지가 있는 경로
img_dir = "assets/ocrimg/"

# OCR 수행 함수
def perform_ocr(image_path):
    result = ocr.ocr(image_path, cls=False)
    ocr_texts = []
    for line in result[0]:
        ocr_texts.append(line[1][0]) 
    return ocr_texts

# OCR 결과를 GET 요청을 통해 제공하는 엔드포인트
@app.route('/result', methods=['GET'])
def get_ocr_result():
    # 최근에 업로드된 이미지 파일 경로 가져오기
    file_times = [(file, os.path.getmtime(os.path.join(img_dir, file))) for file in os.listdir(img_dir)]
    file_times.sort(key=lambda x: x[1], reverse=True)
    recent_file = file_times[0][0]
    recent_file_path = os.path.join(img_dir, recent_file)
    
    # OCR 수행
    ocr_texts = perform_ocr(recent_file_path)

    # 클라이언트에서 하이라이팅할 단어
    highlight_words = [
        "계란",
        "밀",
        "대두",
        "우유",
        "게",
        "새우",
        "돼지고기",
        "닭고기",
        "소고기",
        "고등어",
        "복숭아",
        "토마토",
        "호두",
        "잣",
        "땅콩",
        "아몬드",
        "조개류",
        "기타"
    ]

    # 텍스트에서 특정 단어를 찾아 하이라이팅 적용
    highlighted_texts = []
    for text in ocr_texts:
        highlighted_text = text
        for word in highlight_words:
            if word in highlighted_text:
                highlighted_text = highlighted_text.replace(word, f"<{word}>")
        highlighted_texts.append(highlighted_text)
    

    return jsonify({'text': highlighted_texts}) ,200

# 이미지를 받아서 OCR을 수행하는 엔드포인트
@app.route('/ocr', methods=['POST'])
def ocr_image():
    if 'image' not in request.files:
        return jsonify({'message': '이미지가 없습니다.'}), 400
    
    image = request.files['image']

    if image.filename == '':
        return jsonify({'message': '이미지가 선택되지 않았습니다.'}), 400

    # 이미지를 저장할 경로
    filepath = os.path.join(img_dir, image.filename)
    image.save(filepath)

    # OCR 수행
    ocr_texts = perform_ocr(filepath)

    # 클라이언트에서 하이라이팅할 단어
    highlight_words = [
        "계란",
        "밀",
        "대두",
        "우유",
        "게",
        "새우",
        "돼지고기",
        "닭고기",
        "소고기",
        "고등어",
        "복숭아",
        "토마토",
        "호두",
        "잣",
        "땅콩",
        "아몬드",
        "조개류",
        "기타"
    ]

    # 텍스트에서 특정 단어를 찾아 하이라이팅 적용
    highlighted_texts = []
    for text in ocr_texts:
        highlighted_text = text
        for word in highlight_words:
            if word in highlighted_text:
                highlighted_text = highlighted_text.replace(word, f"<{word}>")
        highlighted_texts.append(highlighted_text)

    

    return jsonify({'text': highlighted_texts}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7000, debug=True)

