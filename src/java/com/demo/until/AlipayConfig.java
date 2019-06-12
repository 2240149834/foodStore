package com.demo.until;

public class AlipayConfig {
	
//↓↓↓↓↓↓↓↓↓↓请在这里配置您的基本信息↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

	// 应用ID,您的APPID，收款账号既是您的APPID对应支付宝账号
	public static String app_id = "2016093000633359";
	
	// 商户私钥，您的PKCS8格式RSA2私钥
    public static String merchant_private_key = "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDKpZScGAFMxVeVip7oCA3FwggTm/4nEGOyAwrReugJdrlsgM5P/c9FT/ukbnJpt8UCiab7FyJFlv1aWfbjrlCfNdlK0gfJfJuyjwxWhTStzqKWbh3tasiAUGGKSEC4hr/RhLn70pWjGOdmkIprg1yCSTsiLxs1x8/IYTf0os4sy3+2pFMSN5GkgRzjw3RWXkZbmjp7TSZlBXcob0zdgkA0qbNZpkj+Po6x/kqzf8aHppOEVkxSAKB7vzXVSU2CvrLBUnlU7WbJ/LsvxweWaki5LMmFECR6HnYwpcihOBljBraGs7NnzOUHzD5ZnIbgHGjof2Av9WNmpHqSjmgVozAfAgMBAAECggEASibOu1N5Xksz4k+IGCWiTIPUisBg/pBbuq6sTbzonVXpQc/cLp8UMiuzTBbyHMcW+ve9t1FexBIdAOu8kNGfRLLioSM7oDnNi0gW3q39ecAL9Hm0z8RsO6+uEXig3iTImfU0TPZgtP6O5hPr4q19s1rynW6ZSVOlL5CLdiQAx5jEjYWAnTVSk8+WOlmd+XLsk1oUH6EOGdsB601qDnmghBficDYOWvCsw7adQ55ZAjgeK6GN0504CFdYzcqCWWTivUCFxgvgKZQ7FlaSsWELbYO7ed4qr+jvLmmr0Jj22dHEmn3Y+ttKWY/6LKe0+bkat1dIcKWHvLGsyY4WBVIduQKBgQDq1vqkShiEn9UtPm9dn3QkgFFP7O062klWWyK407f+Obsgtmnw0xWH4dQ1RHm9ccE1Y4wXeI3mM/ub+mt/Mb3yPLYArSmKMYvrmmpIKydQf7lfNnhZw9HK4yYUH1XrwD/OqVXAXVJDeg9/jQfFeK8bB9nPJ424aSOJZhhHQGpkawKBgQDc6AKa4uqgrNBLjysoKC28zY9xENVZaURoukMH6DsawIuhUJ2e5uc6dIkq0D77BTWbv18mxx5VfZV+XXOpZyP/9XHFQ7t4BTSK77WeJSkw96XQBhdittvPkrUL1m7L+3AaEShom/IrOLeXj7O/0csBddTezUPewx33yjAKOrVwHQKBgHXDGC0KewEGpX/qry3jp/ol3qCVzuCUVfJYATFt+fYiPRRKZRW+xC0/sYqErAez449CPB4I9h9aMfIlwYInD3lJuHreWtZRwjiDVoiaGzziz7JPPkrFR47WGWI91HhED7syby3nnjj4HI15y0vbGPQVG8QlsYuoLYnZCJOyWafBAoGBAMF1ZiKiqvu/nEMvxInMdhGsq/xG07ET4VceF+nq1Sgei6ngYclxSfsFZ8LY0O8gpswZEolxQ/12l98slEg9DWfxWYt6P8liNZufRhyTSrmZh9rgGsbWgTYNswQE7M8zCf+qGwtR1wlHCHFw5egNII3M1XmxpciGc843gU7UD2V5AoGANQf4FdlE0MeR2mUXehfoNqMud0VyHqjuqe0dKY++9ak7YSei7nK3vLQp9JkZz8MlWHeKueAb6jhMhYRcLJUzFzWEvutKjIkKmEHiMSC7eE2izWGBPZK4IV6HIsoQmB+FFTzsnvt78H7HZOYp1bDf2/A0oib0Xs87xdqFtzqAQl4=";

	// 支付宝公钥,查看地址：https://openhome.alipay.com/platform/keyManage.htm 对应APPID下的支付宝公钥。
    public static String alipay_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzQnzb19kSi0emSkQ01DCNLm1Pc+Ht1nByI7xog7ksOfrxR5vBqQmOmox34IyPllMiA/yEWV7+pRpcAMsvMTa0wRFwRDvfumagcUfR7bvJ5Zq8ekclctC5AOB+xdvN4TOTIxM5gDNfbRaMDoRf+KqJT7BtN2lhx2e/hyYU5T+S1UiDivcPZ9D+LLkSCa9kxVb4Qc1GF78rXdCz88uGyoUc0W6ManWF1i4gAggv6WQlHFSolkYW4f1kfmHQG6XACSb8giBN9yfvUJcrVNd6VJ4npyMg2GFofOyWCuWtDFxg+Fdx//09TaLbVS7cST8B5XPZz7hKOOvxT3cZ2UmFXhQMwIDAQAB";

	// 服务器异步通知页面路径  需http://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
	public static String notify_url = "http://localhost:8080/foodStore_war_exploded/alipayNotifyNotice";

	// 页面跳转同步通知页面路径 需http://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
	public static String return_url = "http://localhost:8080/foodStore_war_exploded/alipayReturnNotice";

	// 签名方式
	public static String sign_type = "RSA2";
	
	// 字符编码格式
	public static String charset = "utf-8";
	
	// 支付宝网关
	public static String gatewayUrl = "https://openapi.alipaydev.com/gateway.do";
}

