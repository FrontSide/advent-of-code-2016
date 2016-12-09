#include "triangle.h"

Triangle::Triangle(double m_sideALength, double m_sideBLength, double m_sideCLength) {
  setTriangleFromSideLengths(m_sideALength, m_sideBLength, m_sideCLength);
}

void Triangle::setTriangleFromSideLengths(double m_sideALength, double m_sideBLength, double m_sideCLength){
  TriangleSide sideA;
  sideA.length = m_sideALength;
  m_sideA = sideA;

  TriangleSide sideB;
  sideB.length = m_sideBLength;
  m_sideB = sideB;

  TriangleSide sideC;
  sideC.length = m_sideCLength;
  m_sideC = sideC;
}

bool Triangle::isLegal() {

  if (m_sideA.length + m_sideB.length <=  m_sideC.length)
    return false;

  if (m_sideA.length + m_sideC.length <=  m_sideB.length)
    return false;

  if (m_sideB.length + m_sideC.length <=  m_sideA.length)
    return false;

  return true;

}
