package edu.uqac.aop.chess.aspect;

import edu.uqac.aop.chess.*;
import edu.uqac.aop.chess.agent.*;
import edu.uqac.aop.chess.piece.*;

public aspect CheckMove {
	
	pointcut check(Move mv):
		call(boolean Player.makeMove(Move))
		&& args(.., mv)
		&& target(Player)
		&& !within(CheckMove);
	
	boolean around(Move mv):
	check (mv){
		Player p = (Player) thisJoinPoint.getTarget();
		Board b = p.getPlayGround();
		return checkMove(b, mv) && p.makeMove(mv);
	}
	
	
	protected static boolean checkMove(Board b, Move mv){
		Piece p = b.getGrid()[mv.xI][mv.yI].getPiece();
		if 		(p instanceof Bishop) 	return checkBishop(b, mv, p.getPlayer());
		else if (p instanceof King) 	return checkKing(b, mv, p.getPlayer());
		else if (p instanceof Knight) 	return checkKnight(b, mv, p.getPlayer());
		else if (p instanceof Pawn) 	return checkPawn(b, mv, p.getPlayer());
		else if (p instanceof Queen) 	return checkQueen(b, mv, p.getPlayer());
		else if (p instanceof Rook) 	return checkRook(b, mv, p.getPlayer());
		return false;
	}
	
	
	protected static boolean checkRook(Board b, Move mv, int p) {
		//Impossible de manger ses propres pieces
		if(b.getGrid()[mv.xF][mv.yF].isOccupied() && b.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() == p){
			return false;
		}
		//Impossible si une piece est au milieu du chemin
		if(mv.xF == mv.xI){
			if(mv.yF > mv.yI){
				for(int i = mv.yI + 1; i < mv.yF; i++){
					if(b.getGrid()[mv.xF][i].isOccupied()){
						return false;
					}
				}
			} else {
				for(int i = mv.yI - 1; i > mv.yF; i--){
					if(b.getGrid()[mv.xF][i].isOccupied()){
						return false;
					}
				}
			}
		} else {
			if(mv.xF > mv.xI){
				for(int i = mv.xI + 1; i < mv.xF; i++){
					if(b.getGrid()[i][mv.yF].isOccupied()){
						return false;
					}
				}
			} else {
				for(int i = mv.xI - 1; i > mv.xF; i--){
					if(b.getGrid()[i][mv.yF].isOccupied()){
						return false;
					}
				}
			}
		}
		//Toutes les conditions sont bonnes
		return true;
	}

	protected static boolean checkQueen(Board b, Move mv, int p) {
		if(mv.xF == mv.xI || mv.yF == mv.yI){
			return checkRook(b, mv, p);
		} else {
			return checkBishop(b, mv, p);
		}
	}

	protected static boolean checkKnight(Board b, Move mv, int p) {
		//Impossible de manger ses propres pieces
		if(b.getGrid()[mv.xF][mv.yF].isOccupied() && b.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() == p){
			return false;
		}
		//Toutes les conditions sont bonnes
		return true;
	}

	protected static boolean checkKing(Board b, Move mv, int p) {
		//Impossible de manger ses propres pieces
		if(b.getGrid()[mv.xF][mv.yF].isOccupied() && b.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() == p){
			return false;
		}
		//Toutes les conditions sont bonnes
		return true;
	}

	protected static boolean checkBishop(Board b, Move mv, int p) {
		//Impossible de manger ses propres pieces
		if(b.getGrid()[mv.xF][mv.yF].isOccupied() && b.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() == p){
			return false;
		}
		if(mv.yF > mv.yI && mv.xF > mv.xI){
			for(int i = 1; i < mv.yF - mv.yI; i++){
				if(mv.xI+i < Board.SIZE && b.getGrid()[mv.xI + i][mv.yI + i].isOccupied()){
					return false;
				}
			}
		} 
		if(mv.yF < mv.yI && mv.xF > mv.xI){
			for(int i = 1; i < mv.yI - mv.yF; i++){
				if(mv.xI+i < Board.SIZE && b.getGrid()[mv.xI + i][mv.yI - i].isOccupied()){
					return false;
				}
			}
		} 
		if(mv.yF > mv.yI && mv.xF < mv.xI){
			for(int i = 1; i < mv.yF - mv.yI; i++){
				if(mv.xI-i > -1 && b.getGrid()[mv.xI - i][mv.yI + i].isOccupied()){
					return false;
				}
			}
		} 
		if(mv.yF < mv.yI && mv.xF < mv.xI){
			for(int i = 1; i < mv.yI - mv.yF; i++){
				if(mv.xI-i > -1 && b.getGrid()[mv.xI - i][mv.yI - i].isOccupied()){
					return false;
				}
			}
		} 
		//Toutes les conditions sont bonnes
		return true;
	}

	protected static boolean checkPawn(Board b, Move mv, int p) {
		if(p == Player.BLACK){
			//Pas de retour arriere
			if(mv.yF >= mv.yI) {
				return false;
			}
			//Coup special que si position de depart
			if(mv.yI != 6){
				if(mv.yF < mv.yI - 1) {
					return false;
				} 				
			}
			if(b.getGrid()[mv.xF][mv.yF].isOccupied()){
				//Impossible de manger ses propres pieces
				if(b.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() == Player.BLACK){
					return false;
				} 
				//Impossible de manger tout droit
				else if (mv.xF == mv.xI){
					return false;
				}
			}
			//Impossible d'aller en travers si case non occup�e
			else if(mv.xF != mv.xI){
				return false;
			}
			//Toutes les conditions sont bonnes
			return true;
		} else {
			//Pas de retour arriere
			if(mv.yF <= mv.yI) {
				return false;
			}
			//Coup special que si position de depart
			if(mv.yI != 1){
				if(mv.yF > mv.yI + 1) {
					return false;
				} 				
			}
			if(b.getGrid()[mv.xF][mv.yF].isOccupied()){
				//Impossible de manger ses propres pieces
				if(b.getGrid()[mv.xF][mv.yF].getPiece().getPlayer() == Player.WHITE){
					return false;
				} 
				//Impossible de manger tout droit
				else if (mv.xF == mv.xI){
					return false;
				}
			}
			//Impossible d'aller en travers si case non occup�e
			else if(mv.xF != mv.xI){
				return false;
			}
			//Toutes les conditions sont bonnes
			return true;
		}
	}
}
