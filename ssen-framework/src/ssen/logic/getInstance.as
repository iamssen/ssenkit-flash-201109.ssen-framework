package ssen.logic {
import ssen.common.getQualifiedClassName2;
import ssen.logic.context.DependencyContext;

use namespace logic_internal;

/**
 * Context 에 정의된 dependency instance 를 가져온다
 * @param document instance 를 요청하는 위치, String or instance or Class
 * @param asked dependency 질의
 */
public function getInstance(document:Object, asked:Class,
							named:String = "default"):* {
	var space:String;
	
	if (document is String) {
		space = String(document);
	} else {
		space = getQualifiedClassName2(document);
	}
	return DependencyContext.getInstance().getInstance(space, asked, named);
}
}