
var showbox=(function(tp){
	if(tp == 1)
	{
		pics = picArray1;
	}else
	{
		pics = picArray2;
	}
	$(".picright").show();
	$(".picleft").show();
	picIndex = 0;
	$("#sb_frame img").attr("src","/assets/xcc/"+pics[picIndex]);
	
	setTimeout(function(){
		setsize();
	},200);
});
function showpic(picurl)
{
	$(".picright").hide();
	$(".picleft").hide();
	$("#sb_frame img").attr("src",picurl);
	setTimeout(function(){
		setsize();
	},200);
}
function setsize()
{
	var wh = $(".sb_box_div").width();
	if(wh < 100)
	{
		setTimeout(function(){
			setsize();
		},1000);
	}
	
    $(".sb_box_div").css("left",($("body").width()-wh-20)/2+"px");
    
    // 计算弹出框的层级，需大于原先已有的层
    var zinde =11,z_in,z_in_num;
    $("body").children().each(function(){
        z_in = $(this).css("z-index");
        if(z_in != null && z_in != "auto" && z_in != "undefined")
        {
            z_in_num = parseInt(z_in);
            if(z_in_num > zinde)
            {
                zinde = z_in_num;
            }
        }
    });
    $(".sb_bg_div").css("z-index",zinde);
    $(".sb_box_div").css("z-index",zinde+2);
	 $(".sb_box_div").show();
	  $(".sb_bg_div").show();
}
$(document).ready(function(){
	$(".sb_close").click(function(){
       $(".sb_box_div").css("display","none");
        $(".sb_bg_div").hide();
    });
    
	$(".picleft").click(function(){
		if(picIndex > 0)
		{
			picIndex = picIndex - 1;
			$("#sb_frame img").attr("src","/assets/xcc/"+pics[picIndex]);
			setTimeout(function(){
				setsize();
			},200);
		}
	});
	$(".picright").click(function(){
		if(picIndex < pics.length - 1)
		{
			picIndex = picIndex + 1;
			$("#sb_frame img").attr("src","/assets/xcc/"+pics[picIndex]);
			setTimeout(function(){
				setsize();
			},200);
		}
	});
	$(".menu").hover(function(){
		//$(this).find("> ul").show();
		$(this).find("> ul").slideDown();
	},function(){
		//$(this).find("> ul").hide();
		$(this).find("> ul").slideUp();
	});
	$(".cp span img").click(function(){
		showpic($(this).attr("src"));	
	});

    $(".daohan span").click(function(){
        if($(this).next("ul").is("visible"))
        {
            return;
        }
        $(".daohan ul").hide();
        $(".daohan span label").text("△");
        $(this).next("ul").slideDown();
        $(this).find("label").text("▽");
    });
    $(".daohan> ul >li").click(function(){
        if($(this).hasClass("sel"))
        {
            return;
        }
        $(".daohan> ul >li.sel").removeClass("sel");
        $(this).addClass("sel")
    });
});
var pics = new Array();
var picIndex = 0;
var picArray1 = [
	"1.jpg",
	"2.jpg",
	"3.jpg",
	"4.jpg",
	"5.jpg",
	"6.jpg",
	"7.jpg",
	"8.jpg",
	"9.jpg",
	"10.jpg",
	"11.jpg",
	"12.jpg"
];
var picArray2 = [
	"普之润宣传画册111.jpg",
	"普之润宣传画册1112.jpg",
	"普之润宣传画册1113.jpg",
	"普之润宣传画册1114.jpg",
	"普之润宣传画册1115.jpg",
	"普之润宣传画册1116.jpg",
	"普之润宣传画册1117.jpg",
	"普之润宣传画册1118.jpg",
	"普之润宣传画册1119.jpg"
];
