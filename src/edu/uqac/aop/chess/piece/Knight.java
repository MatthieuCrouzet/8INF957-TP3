package edu.uqac.aop.chess.piece;

import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;

public class Knight extends Piece {

	public Knight(int player) {
		super(player);
	}

	@Override
	public String toString() {
		return ((this.player == Player.WHITE) ? "C" : "c");
	}

	@Override
	public boolean isMoveLegal(Move mv) {
		// TODO Auto-generated method stub
		if (Math.abs(mv.xI - mv.xF) == 2) {
			return Math.abs((mv.yI - mv.yF)) == 1;
		} else if (Math.abs(mv.xI - mv.xF) == 1) {
			return Math.abs((mv.yI - mv.yF)) == 2;
		}
		return false;
	}
}