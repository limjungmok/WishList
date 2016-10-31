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

        when "http://www.mixxmix.com", "http://mixxmix.com"
            mixxmix(breakParameter(params))

        when "http://www.mocobling.com", "http://www.dailymonday.com"
            cafe24_ver_3(breakParameter(params))

        when "http://www.fromgirls.co.kr"
            fromgirls(breakParameter(params))

        when "http://store.musinsa.com"
        	musinsa(breakParameter(params))

        when "http://www.zara.com"
            zara(sUrl)

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

        when "http://www.ba-on.com", "http://www.bit-da.com", "http://www.withyoon.com"
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
            danawa(sUrl)

        when "http://shopping.naver.com"
            naver_shopping(sUrl)

        when "http://shoppingw.naver.com"
            naver_shoppingwindow(sUrl)

        when "http://www.lotteimall.com"
            lotteimall(sUrl)

        when "http://www.oclock.co.kr"
            cjmall(sUrl)
            
        when "http://www.jogunshop.com"
            jogunshop(sUrl)

        when "http://store.melon.com"
            melon(sUrl)

        when "http://www.hyundaihmall.com"
            hyundaihmall(sUrl)

        when "http://m.1300k.com"
            _1300k_mobile(sUrl)
        when "http://www.lotte.com"
            lotte_dotcom(sUrl)

        when "http://www.akmall.com"
            akmall(sUrl)

        when "http://zavino.co.kr"
            zavino(sUrl)
        # when "http://www.giordano.co.kr"
        #     giordano(sUrl)
        when "http://www.beginning.kr"
            beginning(sUrl)

        when "http://www.oliveyoungshop.com"
            oliveyoungshop(sUrl)

        when "http://www.nike.co.kr"
            nike(sUrl)

        when "http://shop.adidas.co.kr"
            adidas(sUrl)

        when "http://www.piece-worker.com"
            pieceworker(sUrl)

        when "http://www.uniqmoment.com"
            uniqmoment(sUrl)
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


    # def site_name(url)
    #     doc = Nokogiri::HTML(open(url))
    #     data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    #     respond_to do |format|
    #         format.html
    #         format.json { render :json => data }
    #     end
    #     @@b_in = true
    # end
    
    # def giordano(url)
    #     doc = Nokogiri::HTML(open(url))
    #     
    #     title = doc.css("meta[@property='og:title']")[0].attributes['content'].value

        
    #     data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
    #     respond_to do |format|
    #         format.html
    #         format.json { render :json => data }
    #     end
    #     @@b_in = true
    # end 

    def uniqmoment(url)

        doc = Nokogiri::HTML(open(url))
        
        title = doc.css("meta[@property='og:title']")[0].attributes['content'].text
        if !doc.css("input[@id='current_price']").empty?
            price = breakComma(doc.css("input[@id='current_price']")[0].attributes['value'].value)
        else
            price = breakComma(doc.css("input[@id='normal_price']")[0].attributes['value'].value)
        end
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value[0..doc.css("meta[@property='og:image']")[0].attributes['content'].value.index("thumb")-2]+".jpg"
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def pieceworker(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css('h2').children[1].text
        if !doc.css("meta[@property='product:sale_price:amount']").empty?
            price = breakComma(doc.css("meta[@property='product:sale_price:amount']")[0].attributes['content'].value)
        else
            price = breakComma(doc.css("meta[@property='product:price:amount']")[0].attributes['content'].value)
        end
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def adidas(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("meta[@property='og:title']")[0].attributes['content'].text.encode("iso-8859-1").force_encoding("utf-8")
        price = breakComma(doc.xpath("//script[@type='text/javascript']")[48].children[0].text[doc.xpath("//script[@type='text/javascript']")[48].children[0].text.index('wp_pars["p"]')+16..doc.xpath("//script[@type='text/javascript']")[48].children[0].text.index('wp_pars["q"]')-5])
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].text

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def nike(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("meta[@property='og:title']")[0].attributes['content'].text
        price = breakComma(doc.css("div[@id='zoomGoodsPrice']").children.text[0..doc.css("div[@id='zoomGoodsPrice']").children.text.index("원")-1])
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].text[0..doc.css("meta[@property='og:image']")[0].attributes['content'].text.index("_80")-1]+"_2000.png"

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def oliveyoungshop(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("meta[@property='og:title']")[0].attributes['content'].text
        price = breakComma(doc.css("input[@name='sale_price']")[0].attributes['value'].text[0..doc.css("input[@name='sale_price']")[0].attributes['value'].text.index("원")-1])
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].text
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def beginning(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css("h3[@class='tit-prd']").children[0].text
        price = breakComma(doc.css("input[@id='price']")[0].attributes['value'].text)
        img = "http://www.beginning.kr"+doc.css("div[@class='thumb']").children[0].attributes['src'].text

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end   
    def zavino(url)
        doc = Nokogiri::HTML(open(url))

        title = doc.css('h3').children[1].text
        if !doc.css("meta[@property='product:sale_price:amount']").empty?
            price = breakComma(doc.css("meta[@property='product:sale_price:amount']")[0].attributes['content'].value)
        else
            price = breakComma(doc.css("meta[@property='product:price:amount']")[0].attributes['content'].value)
        end
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def akmall(url)
        agent = Mechanize.new
        page = agent.get(url)
        doc = Nokogiri::HTML(page.body)
        
        title = doc.css("meta[@property='og:title']")[0].attributes['content'].value
        if !doc.css("meta[@property='product:sale_price:amount']").empty?
            price = breakComma(doc.css("meta[@property='product:sale_price:amount']")[0].attributes['content'].value)
        else
            price = breakComma(doc.css("meta[@property='product:price:amount']")[0].attributes['content'].value)
        end
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}

        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def lotte_dotcom(url)
        doc = Nokogiri::HTML(open(url))

        if !doc.css("div[@class='group_tit']").children.text.empty?
            title = doc.css("div[@class='group_tit']").children.text
        else
            title = doc.css("p[@class='pname']").children.children.text
        end
        if !doc.css("strong[@class='final']").empty?
            price = breakComma(doc.css("strong[@class='final']").children.children[0].text)
        elsif !doc.css("div[@class='before_price']").empty?
            price = breakComma(doc.css("div[@class='before_price']").children.children[0].text)
        else
            price = breakComma(doc.css("strong[@class='big']").children.text)
        end
        if !doc.css("div[@id='fePrdImg01']").empty?
            img = doc.css("div[@id='fePrdImg01']").children[1].attributes['src'].value
        else
            img = doc.css("p[@class='zoom']").children[0].attributes['src'].value
        end

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def _1300k_mobile(url)
        doc = Nokogiri::HTML(open(url))
        title = doc.css("meta[@property='og:title']")[0].attributes['content'].value

        if !doc.css("span[@class='prc_s']").empty?
            price = breakComma(doc.css("span[@class='prc_s']")[0].children.text[0..doc.css("span[@class='prc_s']")[0].children.text.index("원")-1])
        else            
            price = breakComma(doc.css("span[@class='prc_b']")[0].children.text[0..doc.css("span[@class='prc_b']")[0].children.text.index("원")-1])
        end

        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end      
      
    def mixxmix(url)
        doc = Nokogiri::HTML(open(url))

        title_origin = doc.css("tr[@class=' hide xans-record-'] td")[0].text.split "<br>"
        title = String.new
        title_origin.each do |t|
            title = title + t
        end
        if !doc.css("span[@id='span_product_price_sale']").empty?            
            price = breakComma(doc.css("span[@id='span_product_price_sale']")[0].text)
        else
            price = breakComma(doc.css("tr[@class=' xans-record-']").css("strong[@id='span_product_price_text']")[0].text)
        end
        img = doc.css("meta[@property='og:image']")[0]['content']

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end


    def hyundaihmall(url)
        doc = Nokogiri::HTML(open(url))
        title = doc.css("meta[@property='og:title']")[0].attributes['content'].value
        if !doc.css("meta[@property='product:sale_price:amount']").empty?
            price = doc.css("meta[@property='product:sale_price:amount']")[0].attributes['content'].value
        else
            price = doc.css("meta[@property='product:price:amount']")[0].attributes['content'].value
        end
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value[0..doc.css("meta[@property='og:image']")[0].attributes['content'].value.index('jpg')-6]+'.jpg'
      
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}

        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def fromgirls(url)
        doc = Nokogiri::HTML(open(url))

        title_origin = doc.css('title')[0].text.split ""
        title = String.new
        title_origin[1..-2].each do |t|
            title = title + t
        end
        price = breakComma(doc.css("div[@class='prd-price']").css("span[@id='pricevalue']")[0].text)
        img_origin = doc.css("img[@class='detail_image']")[0]['src']
        img = 'http://www.fromgirls.co.kr/' + img_origin

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def melon(url)
        doc = Nokogiri::HTML(open(url))
        title = doc.css("input[@id='prodName']")[0].attributes["value"].value
        price = doc.css("input[@id='dcSellPrice']")[0].attributes["value"].value
        img = doc.css("ul[@class='img_big_list']")[0].children.children[0].attributes['src'].value[0..doc.css("ul[@class='img_big_list']")[0].children.children[0].attributes['src'].value.index("jpg")+2]

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def jogunshop(url)
        doc = Nokogiri::HTML(open(url))
        title = doc.css("title").children.text
        price = breakComma(doc.css("input[@name='price']")[0].attributes['value'].value)
        img = "http://www.jogunshop.com/" + doc.css("div[@class='keyImg']").children[0].attributes['src'].value

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def cjmall(url)
        doc = Nokogiri::HTML(open(url))
        title = doc.css("meta[@property='og:title']")[0].attributes['content'].value
        if !doc.css("strong[@class='cardSale']").empty?
            price = breakComma(doc.css("strong[@class='cardSale']").children[0].text)
        else
            price = breakComma(doc.css("strong[@class='linePrice']")[0].children[0].children.text)
        end
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def lotteimall(url)
        doc = Nokogiri::HTML(open(url))
        
        title = doc.css("meta[@property='og:title']")[0].attributes['content'].value
        if !doc.css("span[@class='price']").children.children[1].nil?
          price = breakComma(doc.css("span[@class='price']").children.children[1].text)
        else
          price = breakComma(doc.css("span[@class='price']").children.children[0].text)
        end
        img = doc.css("meta[@property='og:image']")[0].attributes['content'].value
        
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def naver_shoppingwindow(url)
        doc = Nokogiri::HTML(open(url))
        
        title = doc.css("meta[@name='description']")[0].attributes["content"].value
        if !doc.css("strong[@class='money']").nil?
          price = breakComma(doc.css("strong[@class='money']")[0].children.text)
        else
          price = breakComma(doc.css("span[@class='money']")[0].children.text)
        end
        img = doc.css("meta[@property='og:image']")[0].attributes["content"].value[0..doc.css("meta[@property='og:image']")[0].attributes["content"].value.index("?type")-1]

        
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

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
        encoded_url = URI.encode(url)
        url = URI.parse(encoded_url)

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
        agent = Mechanize.new
        page = agent.get(url)
        doc = Nokogiri::HTML(page.body)
    
        title = doc.xpath("//meta[@property='og:title']/@content")[0].value
        img = "https:"+ doc.css('#image0').children[1].attributes['src'].value
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
        doc = Nokogiri::HTML(open(url).read.encode('utf-8', 'euc-kr'))

        title = doc.css('title').children.text[5..doc.css('title').children.text.length]
        price = breakComma(doc.css('.discount')[0].children.children[1].children.text)
        img = doc.css('#og_image')[0].attributes["content"].value

        
        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def uniqlo(url)
        doc = Nokogiri::HTML(open(url))

        #이미지는 자바스크립트에서 받아와야함
        img_javascript = doc.xpath("//script[@type='text/javascript']")[18].text
        title = doc.css("h2[@id='goodsNmArea']").text[5..doc.css("h2[@id='goodsNmArea']").text.index("\r",7)-1]
        price = breakComma(doc.css("li[@class='price']").text[0..doc.css("li[@class='price']").text.index("원")-1])
        img = img_javascript[img_javascript.index("src_570")+9..img_javascript.index("src_1000")-8]
        
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
        img = doc.xpath("//meta[@property='og:image']/@content")[0].value

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

    def cafe24_ver_3(url)
        doc = Nokogiri::HTML(open(url))

        if url.index("/",8) != nil
            sUrlOriginal = url[0,url.index("/",8)] # url 중 original 주소만 가져 옴
        end
        title_origin = doc.css('title')[0].text.split ""
        title = String.new
        title_origin[1..-2].each do |t|
            title = title + t
        end
        if !doc.css("input[@id='disprice']")[0]['value'].empty?            
            price = breakComma(doc.css("input[@id='disprice']")[0]['value'])
        else
            price = breakComma(doc.css("input[@id='price']")[0]['value'])
        end
        img_origin = doc.css("div[@class='thumb'] img")[0]['src']
        img = sUrlOriginal + img_origin

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
        doc = Nokogiri::HTML(open(url),nil, "UTF-8")

        title = doc.css("meta[@property='og:title']")[0].attributes["content"].value
        if title.index('/')
            title = title[0..(title.index('/')-1)]
        end

        price = breakComma(doc.css("p[@class='fc_point sale']")[0].children[1].children[0].children.text)
        img = doc.css("meta[@property='og:image']")[0].attributes["content"].value[0..doc.css("meta[@property='og:image']")[0].attributes["content"].value.index('?type')-1]
        
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

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def zara(url)
        doc = Nokogiri::HTML(open(url, 'User-Agent' => 'Chrome'))

        title = doc.xpath("//meta[@name='description']/@content")[0].value
        og_price = doc.xpath("//span[@class='price']")[0].attributes['data-price'].value
        price = breakComma(og_price[0..og_price.index("0 ")])
        img = doc.xpath("//div[@class='media-wrap image-wrap full  imageZoom ']")[0].children[1].attributes['href'].value

        data = {:message => "success", :title => title, :price => price ,:img => img, :url => url}
        respond_to do |format|
            format.html
            format.json { render :json => data }
        end
        @@b_in = true
    end

    def naver_shopping(url)
        doc = Nokogiri::HTML(open(url))
        
        title = doc.css("div[@class='h_area'] h2")[0].text
        price = breakComma(doc.css("span[@class='low_price'] em")[0].text)
        img = doc.css("meta[@property='og:image']")[0].attributes["content"].value[0..doc.css("meta[@property='og:image']")[0].attributes["content"].value.index("?type")-1]


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