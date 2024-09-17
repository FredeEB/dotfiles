local ai = require('constants.ai')

require('gp').setup {
    default_chat_agent = "ollama-chat",
    default_command_agent = "ollama-code",

    agents = {
        {
            name = "ollama-chat",
            provider = "ollama",
            chat = true,
            command = true,
            system_prompt = ai.system_prompt,
            model = { model = ai.chat_model },
        },
        {
            name = "ollama-code",
            provider = "ollama",

            chat = false,
            command = true,
            system_prompt = ai.system_prompt,
            model = { model = ai.code_model }
        },
    },
    providers = {
        ollama = {
            endpoint = "http://dt:11434/v1/chat/completions",
        },
    }
}
