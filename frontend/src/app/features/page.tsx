'use client';

import {
  Box,
  Typography,
  Card,
  CardContent,
  CardActions,
  Button,
  Chip,
  Pagination,
  CircularProgress,
  Alert,
  Snackbar,
} from '@mui/material';
import { ThumbUp, Add } from '@mui/icons-material';
import Layout from '@/components/Layout/Layout';
import Link from 'next/link';
import { useFeatures, useVoteFeature } from '@/hooks/useFeatures';
import { useState } from 'react';
import { ApiError } from '@/types/api';

export default function FeaturesPage() {
  const [page, setPage] = useState(1);
  const [voteError, setVoteError] = useState<string | null>(null);
  const limit = 10;
  
  const { data, isLoading, isError, error } = useFeatures(page, limit);
  const voteFeatureMutation = useVoteFeature();

  const handleVote = (featureId: number) => {
    setVoteError(null);
    voteFeatureMutation.mutate(featureId, {
      onError: (error) => {
        const errorMessage = (error as ApiError)?.response?.data?.detail || 'Failed to vote. Please try again.';
        setVoteError(errorMessage);
      }
    });
  };

  const handlePageChange = (_event: React.ChangeEvent<unknown>, value: number) => {
    setPage(value);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  if (isLoading) {
    return (
      <Layout>
        <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '50vh' }}>
          <CircularProgress size={60} />
        </Box>
      </Layout>
    );
  }

  if (isError) {
    return (
      <Layout>
        <Alert severity="error" sx={{ mb: 4 }}>
          {(error as ApiError)?.response?.data?.detail || 'Failed to load features. Please try again.'}
        </Alert>
      </Layout>
    );
  }

  const features = data?.items || [];
  const totalPages = data?.pages || 1;

  return (
    <Layout>
      <Box sx={{ mb: 4 }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
          <Typography variant="h1" component="h1">
            Features
          </Typography>
          <Button
            variant="contained"
            startIcon={<Add />}
            component={Link}
            href="/features/create"
          >
            Propose Feature
          </Button>
        </Box>
        
        <Typography variant="body1" color="text.secondary">
          Browse and vote on feature requests from the community
        </Typography>
        
        {data && (
          <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
            Showing {features.length} of {data.total} features • Page {page} of {totalPages}
          </Typography>
        )}
      </Box>

      {features.length === 0 ? (
        <Box sx={{ textAlign: 'center', py: 8 }}>
          <Typography variant="h3" color="text.secondary" gutterBottom>
            No features yet
          </Typography>
          <Typography variant="body1" color="text.secondary" sx={{ mb: 3 }}>
            Be the first to propose a feature!
          </Typography>
          <Button
            variant="contained"
            startIcon={<Add />}
            component={Link}
            href="/features/create"
          >
            Propose Feature
          </Button>
        </Box>
      ) : (
        <>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
            {features.map((feature) => (
              <Card key={feature.id}>
                <CardContent>
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 2 }}>
                    <Typography variant="h3" component="h2">
                      {feature.title}
                    </Typography>
                    <Chip
                      icon={<ThumbUp />}
                      label={feature.vote_count}
                      color="primary"
                      size="small"
                    />
                  </Box>
                  
                  <Typography variant="body1" color="text.secondary" sx={{ mb: 2 }}>
                    {feature.description}
                  </Typography>
                  
                  <Typography variant="body2" color="text.secondary">
                    By {feature.author.name} • {new Date(feature.created_at).toLocaleDateString()}
                  </Typography>
                </CardContent>
                
                <CardActions>
                  <Button
                    size="small"
                    startIcon={<ThumbUp />}
                    onClick={() => handleVote(feature.id)}
                    disabled={voteFeatureMutation.isPending}
                  >
                    {voteFeatureMutation.isPending ? 'Voting...' : `Vote (${feature.vote_count})`}
                  </Button>
                  <Button 
                    size="small" 
                    color="inherit"
                    component={Link}
                    href={`/features/${feature.id}`}
                  >
                    View Details
                  </Button>
                </CardActions>
              </Card>
            ))}
          </Box>

          {totalPages > 1 && (
            <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
              <Pagination
                count={totalPages}
                page={page}
                onChange={handlePageChange}
                color="primary"
                size="large"
                showFirstButton
                showLastButton
              />
            </Box>
          )}
        </>
      )}
      
      <Snackbar
        open={!!voteError}
        autoHideDuration={6000}
        onClose={() => setVoteError(null)}
      >
        <Alert 
          onClose={() => setVoteError(null)} 
          severity="error"
          sx={{ width: '100%' }}
        >
          {voteError}
        </Alert>
      </Snackbar>
    </Layout>
  );
}