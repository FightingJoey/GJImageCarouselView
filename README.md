# GJImageCarouselView
自己写的Banner轮播图，自动循环，无限轮播。可以设置时间间隔、占位图。可以使用本地图片，也可以加载URL。

Demo工程中用到了喵神的[kingfisher](https://github.com/onevcat/Kingfisher)，一个非常好用的图片下载、缓存的框架，灵感取自于[SDWebImage](https://github.com/rs/SDWebImage)。

# 初始化
```
let imageCarouselView = GJImageCarouselView(
frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth/375*180), 
imageTapBlock: { (index) in
	self.imageTapBlock!(index)
})
imageCarouselView.imageUrlList = ["https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg",
                                  "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-2.jpg",
                                  "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-3.jpg"]
imageCarouselView.autoScrollInterval = 3
```

> 如果你使用AutoLayout进行页面布局的话，需要在布局完成后，调用`layoutIfNeeded()`

# 写在最后
希望大家关注我的简书 [Geselle-Joy](http://www.jianshu.com/u/96ef11d38b00)