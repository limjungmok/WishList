class ParsingController < ApplicationController

	require 'open-uri'
	@@b_in = false
	def findParsingAction()

		sUrl = params[:url]
		

		byebug
		if sUrl.index("/",8) != nil
            sUrlOriginal = sUrl[0,sUrl.index("/",8)] # url 중 original 주소만 가져 옴
        end

        # 액션과 연결시켜 주는 곳
        puts case sUrlOriginal

        when "http://store.musinsa.com"
        	musinsa(sUrl)

        when "http://www.zara.com"

        when "http://www.11st.co.kr" , "http://deal.11st.co.kr"
        	for_11st = params[:url]+"&prdNo="+params[:prdNo]
        	_11st(for_11st)

        when "https://www.coupang.com"
        	coupang(sUrl)
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
    #  	doc = Nokogiri::HTML(open(url))
    # 	doc.css("meta")[5]['content']
    # 	data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    # 	respond_to do |format|
    # 		format.html
    # 		format.json { render :json => data }
    # 	end
    # 	@@b_in = true
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

    def _11st(url)
     	doc = Nokogiri::HTML(open(url))
    	title = doc.css("title")[0].text
    	price = doc.xpath("//meta[@property='price']/@content")[0].value
    	img = doc.xpath("//meta[@property='og:image']/@content")[0].value

    	data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    	respond_to do |format|
    		format.html
    		format.json { render :json => data }
    	end
    	@@b_in = true
    end

    def coupang(url)
    	doc = Nokogiri::HTML(open(url))

    	title = doc.xpath("//meta[@property='og:title']/@content")[0].value
    	img = doc.xpath("//meta[@property='og:image']/@content")[0].value
    	price_original = doc.xpath("//strong[@class='price']").text.split ","
    	price = price_original[0] + price_original[1]

    	data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    	respond_to do |format|
    		format.html
    		format.json { render :json => data }
    	end
    	@@b_in = true
    end

    def breakcomma(price)

    	if price.index(",") == nil

    	else
    		separate_price = price.split ","
    		price = String.new
    		separate_price.each do |f|
    			price = price + f
    		end
    	end

    	return price;
    end
end