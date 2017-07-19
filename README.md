# MVVM_RAC
reactiveCocoa mvvm

##
by chendajie 2017-2018
##

基于reactiveCocoa实现的mvvm
==============================

前言

在做了很长一段时间ios基于MVC模式的开发后，最后都疲于维护自己或者别人写的代码。一直在探究一种更有效清晰易于维护的开发模式。在经过对其他几种现有模式进行实际考察后，最后下定决心对现有一些项目采取MVVM的开发模式，在参考别人框架的基础上，在最近一个项目的实际的mvvm开发过程中总结了一些经验，与大家分享下，也希望不足之处大家多提意见。

核心思想：各模块各司其职，模块解耦。

工程简介

有关MVVM的介绍大家自己上网搜索，在此只介绍我自己关于MVVM具体实现的一种参考（借鉴了网上其他大神的一些写法）。除了封装reactiveCocoa之外，还封装了一些常用框架，如afnetworking，yycache等。便于在该基础工程上快速进行实际开发。


1.封装afnetworking，使用单例子处理网络请求。

2.结合afnetworking与reactiveCocoa实现网络请求。

3.封装yycache，实现网络缓存

4.绑定view与model获取，减轻controller工作，解耦网络请求与controller

5.模块化view与网络请求，提高模块复用性


