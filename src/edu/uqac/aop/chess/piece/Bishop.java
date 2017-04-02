package edu.uqac.aop.chess.piece;

import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;

public class Bishop extends Piece {

	public Bishop(int player) {
		super(player);
	}

	public Bishop() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public String toString() {
		return ((this.player == Player.WHITE) ? "F" : "f");
	}

	@Override
	public boolean isMoveLegal(Move mv) {
		float x = mv.xI - mv.xF;
		float y = mv.yI - mv.yF;
		if (x == 0) {
			return false;
		}
		return Math.abs(y / x) == 1.0;
	}
}
