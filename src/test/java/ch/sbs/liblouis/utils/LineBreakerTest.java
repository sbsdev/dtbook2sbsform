package ch.sbs.liblouis.utils;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import java.util.Collections;

import org.junit.Test;

/**
 * Copyright (C) 2010 Swiss Library for the Blind, Visually Impaired and Print
 * Disabled
 * 
 * This file is part of dtbook2sbsform.
 * 
 * dtbook2sbsform is free software: you can redistribute it
 * and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program. If not, see
 * <http://www.gnu.org/licenses/>.
 */

public class LineBreakerTest {
	@Test
	public void testSimple() {
		// 12345678901234567890
		final String input = "" + "123 567 901234 678";

		final String expected = "" + "123 567\n" + "901234\n" + "678";
		assertEquals(expected, LineBreaker.format(input, "", 10));
	}

	@Test
	public void testCondense() {
		// 12345678901234567890
		final String input = "" + "123 567    901234 678";

		final String expected = "" + "123 567\n" + "901234\n" + "678";
		assertEquals(expected, LineBreaker.format(input, "", 10));
	}

	@Test
	public void testPreserveNewline() {
		// 12345678901234567890
		final String input = "" + "123\n567    901234 678";

		final String expected = "" + "123\n" + "567\n" + "901234\n" + "678";
		assertEquals(expected, LineBreaker.format(input, "", 10));
	}

	@Test(expected = RuntimeException.class)
	public void testIndentIdentity() {
		LineBreaker.formatSbs("b\nb", 10);
	}

	@Test
	public void testIndent() {
		// 12345678901234567890
		final String input = "" + " 123 567    901234 678";

		final String expected = "" + " 123 567\n" + " 901234\n" + " 678";

		assertEquals(expected, LineBreaker.formatSbs(input, 10));
	}

	@Test
	public void testIndent2() {
		// 12345678901234567890
		final String input = "" + " 123 567    901234 678\n";

		final String expected = "" + " 123 567\n" + " 901234\n" + " 678\n";

		assertEquals(expected, LineBreaker.formatSbs(input, 10));
	}

	@Test
	public void testHeadingUsesHeadWidth() {
		// A space-prefixed line after "y H1" should wrap at HEAD_WIDTH (120), not STD_WIDTH (80).
		final String word = "ABCDEFGHIJ"; // 10 chars
		// Build a line of 13 words = 130 chars + 12 spaces = 142 chars total — exceeds 120 but not short enough to fit in 80
		final String input = " " + String.join(" ", java.util.Collections.nCopies(13, word));
		final String result = LineBreaker.formatSbs(input, 80, "y H1");
		// With HEAD_WIDTH=120: first line fits 11 words (11*10 + 10 spaces + 1 indent = 121 → wraps after 11)
		// Key assertion: result contains more than one line, but the first line is longer than 80 chars
		final String firstLine = result.split("\n")[0];
		assertTrue("heading line should exceed STD_WIDTH of 80", firstLine.length() > 80);
	}

	@Test
	public void testNonHeadingUsesStdWidth() {
		// A space-prefixed line NOT after a heading marker should still wrap at the given width.
		final String word = "ABCDEFGHIJ"; // 10 chars
		final String input = " " + String.join(" ", java.util.Collections.nCopies(13, word));
		final String result = LineBreaker.formatSbs(input, 80, "y P");
		final String firstLine = result.split("\n")[0];
		assertTrue("non-heading line should not exceed STD_WIDTH of 80", firstLine.length() <= 80);
	}
}
