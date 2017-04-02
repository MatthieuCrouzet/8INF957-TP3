package edu.uqac.aop.chess.piece;

import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;

public class Pawn extends Piece {

	public Pawn(int player) {
		super(player);
	}

	@Override
	public String toString() {
		return ((this.player == Player.WHITE) ? "P" : "p");
	}

	@Override
	public boolean isMoveLegal(Move mv) {
		// TODO Auto-generated method stub
		boolean special = false;
		// player1
		if (player == Player.WHITE) {
			if ((Math.abs(mv.xF - mv.xI) == 0) && (Math.abs(mv.yF - mv.yI) < 3)) {
				special = true;
			}
			return (((mv.yF - mv.yI) == 1) && (Math.abs(mv.xF - mv.xI) <= 1)) || special;
		}
		// player 2
		if ((Math.abs(mv.xF - mv.xI) == 0) && (Math.abs(mv.yF - mv.yI) < 3)) {
			special = true;
		}
		return (((mv.yF - mv.yI) == -1) && (Math.abs(mv.xF - mv.xI) <= 1)) || special;

	}

}
