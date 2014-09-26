module Marketplace
  module Bot
    module Loaders
      autoload :CompanyLoader, "bot/loaders/company_loader"
      autoload :ListLoader, "bot/loaders/list_loader"
      autoload :OrderLoader, "bot/loaders/order_loader"
    end

    module Parsers
      autoload :CompanyParser, "bot/parsers/company_parser"
      autoload :ListParser, "bot/parsers/list_parser"
      autoload :OrderParser, "bot/parsers/order_parser"
      autoload :OrderParserXml, "bot/parsers/order_parser_xml"
      autoload :ParserFz223, "bot/parsers/parser_fz_223"
      autoload :ParserFz94, "bot/parsers/parser_fz_94"
      autoload :ParserFz44, "bot/parsers/parser_fz_44"
    end
  end
end