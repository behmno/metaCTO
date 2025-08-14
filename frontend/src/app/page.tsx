'use client';

import { Typography, Button, Box, Card, CardContent } from '@mui/material';
import Layout from '@/components/Layout/Layout';
import Link from 'next/link';
import { useAuth } from '@/contexts/AuthContext';

export default function Home() {
  const { isAuthenticated } = useAuth();
  return (
    <Layout>
      <Box sx={{ textAlign: 'center', mb: 4 }}>
        <Typography variant="h1" component="h1" gutterBottom>
          MetaCTO Feature Voting
        </Typography>
        <Typography variant="h2" component="h2" color="text.secondary" gutterBottom>
          Propose and vote on new features
        </Typography>
      </Box>

      <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 4, mb: 6 }}>
        <Card sx={{ flex: 1 }}>
          <CardContent>
            <Typography variant="h3" component="h3" gutterBottom>
              🗳️ Vote on Features
            </Typography>
            <Typography variant="body1" color="text.secondary" paragraph>
              Browse and vote on feature requests from the community. Help prioritize what gets built next.
            </Typography>
            <Button variant="contained" component={Link} href="/features" fullWidth>
              Browse Features
            </Button>
          </CardContent>
        </Card>

        <Card sx={{ flex: 1 }}>
          <CardContent>
            <Typography variant="h3" component="h3" gutterBottom>
              💡 Propose Features
            </Typography>
            <Typography variant="body1" color="text.secondary" paragraph>
              Have an idea for a new feature? Share it with the community and gather support.
            </Typography>
            <Button 
              variant="outlined" 
              component={Link} 
              href={isAuthenticated ? "/features/create" : "/login"} 
              fullWidth
            >
              Get Started
            </Button>
          </CardContent>
        </Card>
      </Box>

      <Box sx={{ textAlign: 'center' }}>
        <Typography variant="body1" color="text.secondary">
          Join the community and help shape the future of our platform
        </Typography>
      </Box>
    </Layout>
  );
}
