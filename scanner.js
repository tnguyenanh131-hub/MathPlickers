function mapNormalizedCardPointToFrame(u, v, minX, maxX, minY, maxY, angleDeg) {
  let rx = u;
  let ry = v;

  if (angleDeg === 90) {
    rx = 1 - v;
    ry = u;
  } else if (angleDeg === 180) {
    rx = 1 - u;
    ry = 1 - v;
  } else if (angleDeg === 270) {
    rx = v;
    ry = 1 - u;
  }

  return {
    px: Math.round(minX + rx * (maxX - minX)),
    py: Math.round(minY + ry * (maxY - minY))
  };
}

function sampleRegionAverageLuma(data, width, height, cx, cy, halfSize) {
  const x0 = Math.max(0, cx - halfSize);
  const x1 = Math.min(width - 1, cx + halfSize);
  const y0 = Math.max(0, cy - halfSize);
  const y1 = Math.min(height - 1, cy + halfSize);

  let sum = 0;
  let count = 0;
  for (let y = y0; y <= y1; y++) {
    for (let x = x0; x <= x1; x++) {
      const idx = (y * width + x) * 4;
      sum += 0.299 * data[idx] + 0.587 * data[idx + 1] + 0.114 * data[idx + 2];
      count++;
    }
  }
  return count > 0 ? sum / count : 128;
}

function decodeCardNumberFromPattern(data, width, height, bounds, angleDeg) {
  const { minX, maxX, minY, maxY } = bounds;
  const boxW = maxX - minX;
  const boxH = maxY - minY;
  if (boxW < 36 || boxH < 36) return null;

  const bitCentersU = [39 / 200, 63 / 200, 87 / 200, 113 / 200, 137 / 200, 161 / 200];
  const bitCenterV = 101 / 200;
  const sampleRadius = Math.max(1, Math.round(Math.min(boxW, boxH) * 0.025));

  const bitLumas = bitCentersU.map((u) => {
    const pt = mapNormalizedCardPointToFrame(u, bitCenterV, minX, maxX, minY, maxY, angleDeg);
    return sampleRegionAverageLuma(data, width, height, pt.px, pt.py, sampleRadius);
  });

  const minBitLuma = Math.min(...bitLumas);
  const maxBitLuma = Math.max(...bitLumas);
  if (maxBitLuma - minBitLuma < 35) return null;

  const bitThreshold = (minBitLuma + maxBitLuma) * 0.5;
  let cardNumber = 0;
  for (let i = 0; i < bitLumas.length; i++) {
    const isOne = bitLumas[i] < bitThreshold ? 1 : 0;
    cardNumber |= isOne << i;
  }

  return cardNumber >= 1 && cardNumber <= 40 ? cardNumber : null;
}

window.PlickersScanner = {
  decodeCardNumberFromPattern,
  mapNormalizedCardPointToFrame,
  sampleRegionAverageLuma
};
