'use client';

import {
  Box,
  Typography,
  Card,
  CardContent,
  TextField,
  Button,
  Alert,
  CircularProgress,
} from '@mui/material';
import { ArrowBack, Save } from '@mui/icons-material';
import Layout from '@/components/Layout/Layout';
import Link from 'next/link';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { featuresAPI } from '@/lib/api';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { ApiError } from '@/types/api';

export default function CreateFeaturePage() {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const router = useRouter();
  const queryClient = useQueryClient();

  const createFeatureMutation = useMutation({
    mutationFn: (data: { title: string; description?: string }) =>
      featuresAPI.createFeature(data),
    onSuccess: () => {
      // Invalidate features list to refresh the data
      queryClient.invalidateQueries({ queryKey: ['features'] });
      router.push('/features');
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;

    createFeatureMutation.mutate({
      title: title.trim(),
      description: description.trim() || undefined,
    });
  };

  return (
    <Layout>
      <Box sx={{ mb: 4 }}>
        <Button
          startIcon={<ArrowBack />}
          component={Link}
          href="/features"
          sx={{ mb: 3 }}
        >
          Back to Features
        </Button>
        
        <Typography variant="h1" component="h1" gutterBottom>
          Propose a New Feature
        </Typography>
        
        <Typography variant="body1" color="text.secondary">
          Share your idea for improving the platform
        </Typography>
      </Box>

      {createFeatureMutation.isError && (
        <Alert severity="error" sx={{ mb: 3 }}>
          {(createFeatureMutation.error as ApiError)?.response?.data?.detail || 
           'Failed to create feature. Please try again.'}
        </Alert>
      )}

      <Card>
        <CardContent>
          <form onSubmit={handleSubmit}>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
              <TextField
                label="Feature Title"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
                fullWidth
                placeholder="Brief, descriptive title for your feature"
                helperText="Keep it concise and clear"
                disabled={createFeatureMutation.isPending}
              />
              
              <TextField
                label="Description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                multiline
                rows={4}
                fullWidth
                placeholder="Describe your feature idea in detail..."
                helperText="Explain what the feature should do and why it would be valuable"
                disabled={createFeatureMutation.isPending}
              />
              
              <Box sx={{ display: 'flex', gap: 2, justifyContent: 'flex-end' }}>
                <Button
                  component={Link}
                  href="/features"
                  disabled={createFeatureMutation.isPending}
                >
                  Cancel
                </Button>
                
                <Button
                  type="submit"
                  variant="contained"
                  startIcon={createFeatureMutation.isPending ? 
                    <CircularProgress size={16} /> : <Save />}
                  disabled={!title.trim() || createFeatureMutation.isPending}
                >
                  {createFeatureMutation.isPending ? 'Creating...' : 'Create Feature'}
                </Button>
              </Box>
            </Box>
          </form>
        </CardContent>
      </Card>
    </Layout>
  );
}