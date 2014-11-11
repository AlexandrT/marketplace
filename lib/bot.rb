module Marketplace
  module Bot
    module Loaders
      autoload :CompanyLoader, "marketplace/bot/loaders/company_loader"
      autoload :ListLoader, "marketplace/bot/loaders/list_loader"
      autoload :OrderLoader, "marketplace/bot/loaders/order_loader"
    end

    module Parsers
      autoload :CompanyParser, "marketplace/bot/parsers/company_parser"
      autoload :ListParser, "marketplace/bot/parsers/list_parser"
      autoload :OrderParser, "marketplace/bot/parsers/order_parser"
      autoload :Base, "marketplace/bot/parsers/base"
      autoload :ParserFz223, "marketplace/bot/parsers/parser_fz_223"
      autoload :ParserFz94, "marketplace/bot/parsers/parser_fz_94"
      autoload :ParserFz44, "marketplace/bot/parsers/parser_fz_44"
    end

    module Workers
      autoload :Worker, "marketplace/bot/workers/worker"
    end

    module Producers
      autoload :Producer, "marketplace/bot/producers/producer"
    end
  end
end