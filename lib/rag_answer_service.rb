class RagAnswerService
  def initialize(chunks:, question:, chat_id:)
    @chunks = chunks
    @question = question
    @client = OpenAI::Client.new
    @chat = Chat.find(chat_id)
  end

  def context
    context = @chunks.map(&:chunk).join(" ")
    context
  end

  def build_prompt
    prompt_context = context

    description = "You are a helpful teachers assistant, and your task is to help the student answer their questions, based on the given context.\n\n The context is given below and will be marked by ##CONTEXT_START## and end with ##CONTEXT_END##. The question will be marked by ##QUESTION_START## and end with ##QUESTION_END##.\n\n Please write your answer in a markdown friendly format\n\n Important: Only answer based on the given context. If the context does not answer the question, tell the user"
    context = "##CONTEXT_START##\n#{prompt_context}\n##CONTEXT_END##\n\n"
    question = "##QUESTION_START##\n#{@question}\n##QUESTION_END##\n\n"

    prompt = description + context + question
    prompt
  end

  def chat_history
    messages = @chat.messages
    chat_history = messages.map do |message|
      {
        role: message.user.present? ? "user" : "system",
        content: message.content
      }
    end
    chat_history
  end


  def call
    prompt = build_prompt
    prev_messages = chat_history

    response = @client.chat(
    parameters: {
        model: "gpt-4o", # Required.
        messages: [ *prev_messages, { role: "user", content: prompt } ], # Required.
        temperature: 0.7
    })

    response["choices"][0]["message"]["content"]
  end
end
