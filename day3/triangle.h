struct TriangleSide {
  double length;
};

class Triangle {

  private:
    TriangleSide m_sideA;
    TriangleSide m_sideB;
    TriangleSide m_sideC;

  public:
    Triangle(double sideALength, double sideBLength, double sideCLength);

    void setTriangleFromSideLengths(double sideALength, double sideBLength, double sideCLength);
    bool isLegal();
};
