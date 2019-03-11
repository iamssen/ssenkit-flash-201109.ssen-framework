package ssen.sql {
import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.filesystem.File;

public class SQLGet {
	private var _q:String;

	private var _conn:SQLConnection;

	private var _sql:File;

	public function SQLGet(sql:File) {
		_conn = new SQLConnection;
		_sql = sql;
		_q = "";
	}

	public function q(query:String):void {
		_q += query;
	}

	public function excute(parameters:Object = null):SQLResult {
		var result:SQLResult;
		_conn.open(_sql);

		try {
			var stmt:SQLStatement = new SQLStatement;
			stmt.sqlConnection = _conn;
			stmt.text = _q;
			if (parameters) {
				for (var k:String in parameters) {
					stmt.parameters[":" + k] = parameters[k];
				}
			}
			stmt.execute();
			result = stmt.getResult();
		} catch (error:SQLError) {
			
		}

		_conn.close();
		_q = "";

		return result;

	}
}
}