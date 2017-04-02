package edu.uqac.aop.chess.piece;

import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;

public class Rook extends Piece {

	public Rook(int player) {
		super(player);
	}

	public Rook() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public String toString() {
		return ((this.player == Player.WHITE) ? "T" : "t");
	}

	@Override
	public boolean isMoveLegal(Move mv) {
		// TODO Auto-generated method stub
		return (( mv.yI - mv.yF) == 0) || ((mv.xI - mv.xF) == 0);
	}
}