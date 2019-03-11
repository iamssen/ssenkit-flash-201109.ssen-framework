package ssen.sql {
import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.filesystem.File;

public class SQLPut {
	private var _q:String;

	private var _stmt:Vector.<SQLStatement>;

	private var _conn:SQLConnection;

	private var _sql:File;

	public function SQLPut(sql:File) {
		_conn = new SQLConnection;
		_sql = sql;
		_q = "";
		_stmt = new Vector.<SQLStatement>;
	}

	public function q(query:String):void {
		_q += query;
	}

	public function excute(parameters:Object = null):void {
		var stmt:SQLStatement = new SQLStatement;
		stmt.text = _q;
		if (parameters) {
			for (var k:String in parameters) {
				stmt.parameters[":" + k] = parameters[k];
			}
		}
		_q = "";

		_stmt.push(stmt);
	}

	public function commit():Boolean {
		var result:Boolean;

		_conn.open(_sql);
		_conn.begin();

		try {
			var stmt:SQLStatement;

			var f:int = -1;
			var max:int = _stmt.length;
			while (++f < max) {
				stmt = _stmt[f];
				stmt.sqlConnection = _conn;
				stmt.execute();
			}

			_conn.commit();
			result = true;
		} catch (error:SQLError) {
			
			_conn.rollback();
			result = false;
		}

		_conn.close();
		_stmt.length = 0;

		return result;
	}
}
}