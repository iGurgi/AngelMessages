/**
 * API Version Middleware
 * Validates Accept header for supported API versions
 */

const SUPPORTED_VERSIONS = {
  'application/vnd.angelmessages.v1+json': 'v1'
};

const ApiVersion = (req, res, next) => {
  const acceptHeader = req.get('Accept');
  
  // If no Accept header is provided, default to v1
  if (!acceptHeader) {
    req.apiVersion = 'v1';
    return next();
  }
  
  // Check if the Accept header matches any supported version
  const supportedVersion = SUPPORTED_VERSIONS[acceptHeader];
  
  if (!supportedVersion) {
    return res.status(406).json({
      error: 'Not Acceptable',
      message: 'Unsupported API version',
      supportedVersions: Object.keys(SUPPORTED_VERSIONS),
      received: acceptHeader
    });
  }
  
  // Set the API version on the request object for downstream use
  req.apiVersion = supportedVersion;
  next();
};

module.exports = ApiVersion;