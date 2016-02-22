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

        when "http://www.wemakeprice.com", "http://wemakeprice.com"
            wemakeprice(breakParameter(params))

        when "http://www.ticketmonster.co.kr"
            ticketmonster(breakParameter(params))

        when "http://www.uniqlo.kr"
            uniqlo(breakParameter(params))

        when "http://www.ba-on.com", "http://www.bit-da.com"
            cafe24_ver_1(breakParameter(params))

        when "http://www.moxnix.co.kr", "http://www.bonzishop.com"
            cafe24_ver_2(breakParameter(params))

        when "http://www.underthetoe.com", "http://underthetoe.com"
            underthetoe(breakParameter(params))        

        when "http://www.ssfshop.com"
        	_8seconds(breakParameter(params))

        when "http://www.spao.com", "http://base.spaokr.cafe24.com"
        	spao(breakParameter(params))

        when "http://www.topten10.co.kr"
        	topten10(breakParameter(params))

        when "http://book.interpark.com"
        	interpark_book(breakParameter(params))

        when "http://www.interpark.com"
        	interpark(breakParameter(params))

        when "http://www.29cm.co.kr"
            _29cm(breakParameter(params))

        when "http://www.hm.com"
            hnm(breakParameter(params))

        when "http://www.abcmart.co.kr"
            abcmart(breakParameter(params))

        when "http://storefarm.naver.com"
            storefarm(breakParameter(params))

        when "http://www.ikea.com"
            ikea(breakParameter(params))

        when "http://www.wconcept.co.kr"
            wconcept(breakParameter(params))

        when "http://www.66girls.co.kr"
            _66girls(breakParameter(params))

        when "http://prod.danawa.com"
            danawa(breakParameter(params))
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
                        if !value.nil?
    					   sFinalUrl = sFinalUrl + "&" + key + "=" + value
                        end
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

        if !url.index("&search_keyword").nil?
            url = url[0..url.index("&search_keyword")-2]
        end

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

        if !url.index("?source").nil?
            url = url[0..url.index("?source")-2]
        end

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
        if !url.index("keyword").nil?
            url = url[0..url.index("keyword")-2]
        end
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

        img_javascript = doc.xpath("//script[@type='text/javascript']")[18].text

        title = doc.css("h2[@id='goodsNmArea']").text[5..doc.css("h2[@id='goodsNmArea']").text.index("\r",7)-1]
        price = breakComma(doc.css("li[@class='price']").text[0..doc.css("li[@class='price']").text.index("원")-1])

        img = img_javascript[img_javascript.index("src_570")+9..img_javascript.index("src_1000")-8]

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

    def cafe24_ver_1(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("tr[@class=' xans-record-'] td")[0].text
        price = breakComma(doc.css("tr[@class=' xans-record-'] strong").text)
        img = doc.css("div[@class='xans-element- xans-product xans-product-image imgArea ']").css("div[@class='keyImg'] img")[0]['src']

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def cafe24_ver_2(url)
        doc = Nokogiri::HTML(open(url))

        title_origin = doc.css("div[@id='prdInfo'] h3")[0].text.split " "

        title = String.new
        title_origin.each do |t|
            title = title + " " + t
        end

        price = breakComma(doc.css("span[@id='span_product_price_text']").text)
        img = doc.css("div[@class='xans-element- xans-product xans-product-image ']").css("div[@class='keyImg'] img")[0]['src']
    
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def underthetoe(url)
        doc = Nokogiri::HTML(open(url))

        title_origin = doc.css("div[@id='prdInfo'] h3")[0].text.split " "

        title = String.new
        title_origin.each do |t|
            title = title + " " + t
        end

        price = breakComma(doc.css("strong[@id='span_product_price_text']").text)
        img = doc.css("div[@class='xans-element- xans-product xans-product-image ']").css("div[@class='keyImg'] img")[0]['src']
   
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def _8seconds(url)
     	doc = Nokogiri::HTML(open(url))

     	title = doc.xpath("//meta[@property='og:title']/@content")[0].value
     	price = breakComma(doc.xpath("//strong[@id='sPriceStrong']").text)
     	img = doc.xpath("//meta[@property='og:image']/@content")[0].value

    	data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    	respond_to do |format|
    		format.html
    		format.json { render :json => data }
    	end
    	@@b_in = true
    end

    def spao(url)
     	doc = Nokogiri::HTML(open(url))

     	title = doc.xpath("//meta[@property='og:title']/@content")[0].value
     	price = doc.xpath("//meta[@property='product:sale_price:amount']/@content")[0].value
     	img = doc.xpath("//meta[@property='og:image']/@content")[0].value

    	data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    	respond_to do |format|
    		format.html
    		format.json { render :json => data }
    	end
    	@@b_in = true
    end

    def topten10(url)
     	doc = Nokogiri::HTML(open(url))

     	title = doc.xpath("//meta[@property='product:plural_title']/@content")[0].value
     	price = doc.xpath("//meta[@property='product:price:amount']/@content")[0].value
     	img = doc.xpath("//meta[@property='product:image']/@content")[0].value

    	data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    	respond_to do |format|
    		format.html
    		format.json { render :json => data }
    	end
    	@@b_in = true
    end

    def interpark_book(url)
     	doc = Nokogiri::HTML(open(url))

     	title = doc.xpath("//div[@class='prod_title']").children[1].text
     	img = doc.xpath("//div[@class='imgBox']").children[3].attributes['src'].value
     	price = doc.xpath("//input[@id='DISP_SALE_UNITCOST']")[0].attributes['value'].value

    	data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    	respond_to do |format|
    		format.html
    		format.json { render :json => data }
    	end
    	@@b_in = true
    end

    def interpark(url)
     	doc = Nokogiri::HTML(open(url))

     	title = doc.xpath("//textarea[@id='prdTitle']").text[doc.xpath("//textarea[@id='prdTitle']").text.index("\r")+5..doc.xpath("//textarea[@id='prdTitle']").text.length-1]
     	img = doc.xpath("//div[@class='prdBoxImg']")[0].children[1].attributes['src'].value
     	price = breakComma(doc.xpath("//td[@class='salePrice']")[0].children.children[0].children.text)

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
        doc = Nokogiri::HTML(open(url, 'User-Agent' => 'ruby'))

        title_s= doc.css("meta[@property='og:title']")[0].attributes["content"].value.encode("iso-8859-1").force_encoding("utf-8")
        title = title_s.split("￦")[0]
        price_s = title_s.split("￦")
        price = breakComma(price_s[1])
        img = doc.css("div[@class='zoomable']")[0].children[1].attributes["src"].value[2..doc.css("div[@class='zoomable']")[0].children[1].attributes["src"].value.length]

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

    def storefarm(url)
      doc = Nokogiri::HTML(open(url))
      title = doc.css("meta[@property='og:title']")[0].attributes["content"].value
      price = breakComma(doc.css("p[@class='sale']")[0].children.children.children[0].text)
      img = doc.css("meta[@property='og:image']")[0].attributes["content"].value

      data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
      respond_to do |format|
          format.html
          format.json { render :json => data }
      end
      @@b_in = true
    end

    def ikea(url)
      doc = Nokogiri::HTML(open(url))
      title = doc.css("meta[@property='og:title']")[0].attributes['content'].value
      price = breakComma(doc.css("meta[@name='price']")[0].attributes['content'].value[2..doc.css("meta[@name='price']")[0].attributes['content'].value.length])
      img = doc.css("meta[@property='og:image']")[0].attributes['content'].value

      data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
      respond_to do |format|
          format.html
          format.json { render :json => data }
      end
      @@b_in = true
    end


    def wconcept(url)
      doc = Nokogiri::HTML(open(url))
      if(!doc.css("p[@class='productName']").children.text.index(']').nil?)
        title = doc.css("p[@class='productName']").children.text[doc.css("p[@class='productName']").children.text.index("]")+1..doc.css("p[@class='productName']").children.text.length]
      else
        title = doc.css("p[@class='productName']").children.text[12..doc.css("p[@class='productName']").children.text.length]
      end

      price = breakComma(doc.css("dd[@class='salePrice']").children.text[0..doc.css("dd[@class='salePrice']").children.text.index("원")-1])
      img = doc.css("input[@name='ITEM_IMAGE']")[0].attributes['value'].value
    #byebug
      data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
      respond_to do |format|
          format.html
          format.json { render :json => data }
      end
      @@b_in = true
    end

    def _66girls(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("meta[@property='og:title']")[0].attributes['content'].value
        price = doc.css("meta[@property='product:price:amount']")[0].attributes['content'].value
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}        
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
            @@b_in = true    
    end    

    def danawa(url)
        doc = Nokogiri::HTML(open(url, 'User-Agent' => 'ruby'))
        title = doc.css("meta[@property='og:title']")[0].attributes['content'].value
        price = breakComma(doc.css("span[@class='now_price3 red_price3']")[0].children.children.text[0..doc.css("span[@class='now_price3 red_price3']")[0].children.children.text.index("원")-1])
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value[0..doc.css("meta[@property='og:image']")[0].attributes['content'].value.index("160")-2]+'.jpg'

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
          format.html
          format.json { render :json => data }
      end
      @@b_in = true
    end
end