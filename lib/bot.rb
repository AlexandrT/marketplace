module Marketplace
  module Bot
    module Loaders
      autoload :PageLoader, "marketplace/bot/loaders/page_loader"
    end

    module Parsers
      autoload :Base, "marketplace/bot/parsers/base"
      autoload :ListParser, "marketplace/bot/parsers/list_parser"
      autoload :ParserFz223, "marketplace/bot/parsers/parser_fz_223"
      autoload :ParserFz94, "marketplace/bot/parsers/parser_fz_94"
      autoload :ParserFz44, "marketplace/bot/parsers/parser_fz_44"
    end

    module Workers
      autoload :LoadWorker, "marketplace/bot/workers/load_worker"
      autoload :ParseWorker, "marketplace/bot/workers/parse_worker"
    end

    module Producers
      autoload :Producer, "marketplace/bot/producers/producer"
    end
  end
end