# app/services/commentary_generator.rb
class CommentaryGenerator
  require "net/http"
  require "json"

  API_ENDPOINT = "https://api.openai.com/v1/chat/completions"
  API_KEY = "<REDACTED>"

  def self.generate
    # payload = {
    #   model: "llama3.2",
    #   messages: [
    #     { role: "system", content: system_message },
    #     { role: "user",   content: user_message }
    #   ],
    #   stream: false,
    #   format: format
    # }

    payload = {
      model: "gpt-4o",
      messages: [
        {
            role: "system",
            content: "You are a helpful assistant."
        },
        {
            role: "user",
            content: "Write a haiku that explains the concept of recursion."
        }
      ],
      stream: false,
      temperature: 0.7
    }

    uri = URI(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{API_KEY}"
    })
    request.body = payload.to_json

    response = http.request(request)
    puts response.body.force_encoding("UTF-8")
  end

  def self.user_message
    "Genesis 1:1"
  end

  def self.system_message
    <<~SYS
    You are an AI providing verse-by-verse (or section-by-section) commentary on
    passages from the Bible. Your commentary should be:

    1. Faithful to Scripture - Approach the text with the conviction that it is
       the inspired, inerrant Word of God.
    2. Contextually Rich - Explain the historical, cultural, and linguistic
       background while highlighting key theological truths. Reference relevant
       scriptures from both the Old and New Testaments.
    3. Doctrinally Sound - Reflect traditional Christian interpretations across
       different denominations, including Protestant, and early Church perspectives,
       while staying faithful to biblical doctrine.
    4. Christ-Centered - When applicable, show how the passage connects to Jesus
       Christ, salvation, and God's overarching redemptive plan.
    5. Clear and Reliable - Avoid speculation and ensure clarity for both new
       and seasoned Bible readers.
    6. Believer's Perspective - Speak as one who trusts, obeys, and delights in
       God's Word, guiding readers with reverence and faith.
    7. Approachable and Engaging - Maintain a friendly, conversational
       tone—neither overly academic nor robotic.
    8. Personal and Reflective - Make the commentary thoughtful and relatable,
       encouraging deeper meditation on God's truth.
    9. Expositional and Practical - Explain the passage clearly, making it
       applicable to daily life, ministry, and Christian living while maintaining
       depth and accessibility so that the commentary is not just informative but
       also spiritually edifying and actionable.

    Your goal is to equip readers with a deeper understanding of God's Word,
    strengthening their faith and guiding their walk with Christ.
  SYS
  end

  def self.format1
<<~SYS
    {
    "type": "object",
    "properties": {
      "name": {
        "type": "string"
      },
      "capital": {
        "type": "string"
      },
      "languages": {
        "type": "array",
        "items": {
          "type": "string"
        }
      }
    },
    "required": [
      "name",
      "capital",
      "languages"
    ]
  }
SYS
  end

  def self.format
<<~SYS
{
  "$schema": "http://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "passage": {
      "type": "string",
      "description": "The Bible passage being commented on."
    },
    "context": {
      "type": "string",
      "description": "Historical, cultural, and linguistic background of the passage."
    },
    "key_themes": {
      "type": "array",
      "description": "Main theological themes in the passage.",
      "items": {
        "type": "object",
        "properties": {
          "theme": { "type": "string" },
          "description": { "type": "string" }
        },
        "required": ["theme", "description"]
      }
    },
    "highlights": {
      "type": "array",
      "description": "Key phrases from the passage with explanations.",
      "items": {
        "type": "object",
        "properties": {
          "text": { "type": "string" },
          "explanation": { "type": "string" }
        },
        "required": ["text", "explanation"]
      }
    },
    "expositions": {
      "type": "array",
      "description": "Verse-by-verse exposition, explaining key phrases.",
      "items": {
        "type": "object",
        "properties": {
          "verse": { "type": "string" },
          "fragments": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "quote": { "type": "string" },
                "note": { "type": "string" }
              },
              "required": ["quote", "note"]
            }
          }
        },
        "required": ["verse", "fragments"]
      }
    },
    "cross_references": {
      "type": "array",
      "description": "Other Bible passages that relate to this passage.",
      "items": {
        "type": "object",
        "properties": {
          "reference": { "type": "string" },
          "note": { "type": "string" }
        },
        "required": ["reference", "note"]
      }
    },
    "application": {
      "type": "array",
      "description": "Practical takeaways and applications for Christian living.",
      "items": {
        "type": "object",
        "properties": {
          "title": { "type": "string" },
          "note": { "type": "string" }
        },
        "required": ["title", "note"]
      }
    },
    "christ_centered_insight": {
      "type": "string",
      "description": "How the passage connects to Jesus Christ, salvation, and God's redemptive plan."
    },
    "reflection": {
      "type": "string",
      "description": "A reflective question or meditation prompt based on the passage."
    }
  },
  "required": [
    "passage",
    "context",
    "key_themes",
    "highlights",
    "expositions",
    "cross_references",
    "application",
    "christ_centered_insight",
    "reflection"
  ]
}
SYS
  end
end
