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

        when "http://itempage3.auction.co.kr"
            auction(sUrl)
        when "http://www.wemakeprice.com"
            wemakeprice(sUrl)
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

    def wemakeprice(url)
        doc = Nokogiri::HTML(open(url))
   

        title_s = doc.css('h4').children[0].text
        title = title_s[4..title_s.length]
        price = doc.css('li').css('.sale').children[0].children.text
        price_s = price.split ","
        price = price_s[0] + price_s[1]
        img = doc.css('meta')[9].attributes['content'].value
       
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end

        @@b_in = true 
    end


    def auction(url)
        doc = Nokogiri::HTML(open(url).read.encode('utf-8', 'euc-kr'))

        title = doc.css('.product div')[0].children[1].attributes['alt'].value
        price_origin = doc.css('.product div')[1].children.children[2].children.text
        price_temp = price_origin.split "원"
        price_s = price_temp[0].split ","
        price = price_s[0] + price_s[1]
        img = doc.css('.product div')[0].children[1].attributes['src'].value

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}

        respond_to do |format|
            format.html
            format.json { render :json => data }
        end

        @@b_in = true 
    end
end