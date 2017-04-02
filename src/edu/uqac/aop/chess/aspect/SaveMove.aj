package edu.uqac.aop.chess.aspect;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import edu.uqac.aop.chess.Chess;
import edu.uqac.aop.chess.agent.*;

public aspect SaveMove {
	private String filename = "MovesSave.txt";
	
	private void saveMove(Move mv){
		try {
		    Files.write(Paths.get(filename), (mv.toString() + "\n").getBytes(), StandardOpenOption.APPEND);
		}catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	pointcut newGame():
		call (* Chess.play())
		&& target(Chess);
	
	pointcut newMove():
		   call (Move Player.makeMove()) 
		&& target(Player);
	
	
	after () returning (Move mv):
	newMove() {
		saveMove(mv);
	}
	
	before():
	newGame() {
		try {
			Files.deleteIfExists(Paths.get(filename));
			Files.createFile(Paths.get(filename));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
