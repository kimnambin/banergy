from openai import OpenAI
import base64

open_key = "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"
client = OpenAI(api_key=open_key)

MODEL="gpt-4o"

input = "음식 레시피 자세히 알려줘. 해당 재료의 칼로리도 함께 포함해서 알려줘."
image_path = "./data/test.jpg"


# Open the image file and encode it as a base64 string
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode("utf-8")

base64_image = encode_image(image_path)

response = client.chat.completions.create(
    model=MODEL,
    messages=[
        {"role": "system", "content": "You are a helpful assistant that responds in Markdown. Help me with my math homework!"},
        {"role": "user", "content": [
            {"type": "text", "text": input},
            {"type": "image_url", "image_url": {
                "url": f"data:image/png;base64,{base64_image}"}
            }
        ]}
    ],
    temperature=0.0,
)

result = response.choices[0].message.content
print(result)
