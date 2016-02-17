class ParsingController < ApplicationController

	require 'open-uri'
	@@b_in = false
	def findParsingAction()

		sUrl = params[:url]
        #sUrl = "store.musinsa.com/app/product/detail/282220/0"

        if sUrl.index("/",8) != nil
            sUrlOriginal = sUrl[0,sUrl.index("/",8)] # url 중 original 주소만 가져 옴
        end

        # 액션과 연결시켜 주는 곳
        puts case sUrlOriginal

        when "http://store.musinsa.com"
        	musinsa(sUrl)

        when "http://www.zara.com"

        when "http://item2.gmarket.co.kr"
            gmarket(sUrl)

        end

        if @@b_in == false

        	data = {:message => "fail"}

        	respond_to do |format|
        		format.html
        		format.json { render :json => data }
        	end
        end

        @@b_in = false
    end

    #사이트 기본 액션 템플렛
    # def site_name(url)
    #     doc = Nokogiri::HTML(open(url))
    #     doc.css("meta")[5]['content']
    # end

    def musinsa(url)
    	doc = Nokogiri::HTML(open(url))

    	title_with_price = doc.css("meta")[5]['content']

    	title = title_with_price[0,title_with_price.index(" - ")]
    	price = title_with_price[title_with_price.index(" - ")+3..title_with_price.index(" | ")-2]
    	price_s = price.split ","
    	price = price_s[0] + price_s[1]
    	img = doc.css("meta")[6]['content']

    	data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}

    	respond_to do |format|
    		format.html
    		format.json { render :json => data }
    	end

    	@@b_in = true
    end

    def gmarket(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("meta[@property='twitter:description']")[0]['content']
        price_1 = doc.css("span[@id='dc_price']").text.split("원")[0]
        price_2 = price_1.split(",")
        price = price_2[0] + price_2[1]
        img = doc.css("meta[@property='twitter:image:src']")[0]['content']

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}

        respond_to do |format|
            format.html
            format.json { render :json => data }
        end

        @@b_in = true
    end
end