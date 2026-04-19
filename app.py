# A simple mock AI script for the demo
def analyze_sentiment(text):
    # In a real scenario, this would call an LLM or a local model
    if "error" in text.lower():
        return "Negative"
    return "Positive"

if __name__ == "__main__":
    sample_log = "System booting normally. No errors detected."
    print(f"Analyzing Log: {sample_log}")
    print(f"AI Assessment: {analyze_sentiment(sample_log)}")