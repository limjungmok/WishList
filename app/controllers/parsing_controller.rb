class ParsingController < ApplicationController

	require 'open-uri'
	@@b_in = false
	def findParsingAction()

		sUrl = params[:url]
		
		if sUrl.index("/",8) != nil
            sUrlOriginal = sUrl[0,sUrl.index("/",8)] # url 중 original 주소만 가져 옴
        end

        # 액션과 연결시켜 주는 곳
        puts case sUrlOriginal
        when "http://store.musinsa.com"
        	musinsa(breakParameter(params))

        when "http://www.zara.com"

        when "http://www.11st.co.kr" , "http://deal.11st.co.kr"
        	_11st(breakParameter(params))

        when "https://www.coupang.com" , "http://www.coupang.com"
        	coupang(breakParameter(params))

        when "http://item2.gmarket.co.kr"
            gmarket(breakParameter(params))

        when "http://itempage3.auction.co.kr"
            auction(breakParameter(params))
            
        when "http://www.wemakeprice.com"
            wemakeprice(breakParameter(params))

        when "http://www.ticketmonster.co.kr"
            ticketmonster(breakParameter(params))

        when "http://www.uniqlo.kr"
            uniqlo(breakParameter(params))

        when "http://www.29cm.co.kr"
            _29cm(breakParameter(params))


        when "http://www.hm.com"
            hnm(breakParameter(params))

        when "http://www.abcmart.co.kr"
            abcmart(breakParameter(params))
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

    def breakComma(price)
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

    def breakParameter(params)
    	sFinalUrl = params[:url]
    	index = 0

    	if params.count > 4
    		params.each do |key,value|
    			if index < params.count - 3
    				if index > 0
    					sFinalUrl = sFinalUrl + "&" + key + "=" + value
    				end
    			end
    			index = index + 1
    		end
    	end

    	return sFinalUrl
    end

    #사이트 기본 액션 템플렛
    # def site_name(url)
    #  	doc = Nokogiri::HTML(open(url))
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
    	price = breakComma(doc.xpath("//strong[@class='price']").text)

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
        price = breakComma(doc.css("span[@id='dc_price']").text.split("원")[0])
        img = doc.css("meta[@property='twitter:image:src']")[0]['content']

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
        price = breakComma(doc.css('li').css('.sale').children[0].children.text)
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

    def uniqlo(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("h2[@id='goodsNmArea']").text[5..doc.css("h2[@id='goodsNmArea']").text.index("\r",7)-1]
        price = breakComma(doc.css("li[@class='price']").text[0..doc.css("li[@class='price']").text.index("원")-1])
        
        if img = doc.css("ul[@id='prodThumbImgs']")[0].children[1].children[1].attributes["href"].value
            #착샷부분이 있으면 가져오고
        else
            img = doc.css("p[@class='tumb_img']")[0].children.children[0].attributes["src"].value
            #없으면 비슷한놈꺼 가져온다
        end

        #이미지는 자바스크립트에서 받아와야함

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end


    def ticketmonster(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("h3[@class='tit']")[0].children[0]['alt']
        price = breakComma(doc.css("div[@class='lately on']").css("div[@class='lst']").css("div[@class='detail'] span em").text)
        img = doc.css("ul[@class='roll']")[0].children.children[1].attributes["src"].value

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def _29cm(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("meta[@property='og:title']")[0].attributes['content'].value

        if !doc.css("div[@class='price']").empty?            
            price = breakComma(doc.css("div[@class='price']")[0].children.text[doc.css("div[@class='price']")[0].children.text.index(" ")+12..doc.css("div[@class='price']")[0].children.text.index("won")-1])    
        else
            price = breakComma(doc.css("div[@class='o']")[0].children.text[0..doc.css("div[@class='o']")[0].children.text.index("won")-1])            
        end
 
        img = doc.css("link[@rel='image_src']")[0].attributes["href"].value[0..doc.css("link[@rel='image_src']")[0].attributes["href"].value.index("?")-1]

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def hnm(url)
        doc = Nokogiri::HTML(open(url))

        title_s= doc.css("meta[@property='og:title']")[0].attributes["content"].value.encode("iso-8859-1").force_encoding("utf-8")
        title = title_s.split("￦")[0]
        price_s = title_s.split("￦")
        price = breakComma(price_s[1])
        img = doc.css("div[@class='zoomable']")[0].children[1].attributes["src"].value
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def abcmart(url)
      doc = Nokogiri::HTML(open(url))
      title = doc.css("p[@class='korea']").children.text
      price = breakComma(doc.css("span[@class='price']").children.children.text)
      img = doc.css("div[@class='product_photo']").children.children[1].attributes["src"].value

      data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
      respond_to do |format|
          format.html
          format.json { render :json => data }
      end
      @@b_in = true
    end
end